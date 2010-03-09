package dhl.aar;

import dhl.sys.ApplicationParams;
import dhl.users.Asutus;
import dvk.core.CommonMethods;
import java.sql.Connection;
import java.util.Calendar;
import java.util.Date;

public class AarSyncronizer implements Runnable {
    Thread t;
    Connection dbConn;
    int syncDelay = 0;

    public void init(Connection conn, int syncDelay) {
        try {
            this.t = new Thread(this);
            this.dbConn = conn;
            this.syncDelay = syncDelay;
            
            // Vigaste seadetega threadi k�ima ei t�mba
            if ((this.dbConn != null) && (this.syncDelay > 0)) {
                this.t.start();
            } else {
                CommonMethods.closeConnectionSafely(this.dbConn);
            }
        } catch (Exception ex) {
            CommonMethods.closeConnectionSafely(this.dbConn);
        }
    }

    public void run() {
        try {
            ApplicationParams params = new ApplicationParams(this.dbConn);
            Date markerDate = new Date(0L);  // Kauge minevik
            if (params.getLastAarSync() != null) {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(params.getLastAarSync());
                calendar.add(Calendar.MINUTE, this.syncDelay);
                markerDate = (calendar.getTime());
            }
            
            Calendar now = Calendar.getInstance();
            now.setTime(new Date());
            Calendar currentSync = Calendar.getInstance();
            currentSync.setTime(markerDate);
            
            // Kui praegune hetk on hilisem planeeritud s�nkroniseerimise ajast,
            // siis k�ivitame s�nkroniseerimise
            if (now.after(currentSync)) {
                // M�rgime seadetesse viimase s�nkroniseerimise kuup�evaks
                // praeguse hetke.
                // Teeme seda igaks juhuks enne realset s�nkroniseerimist, kuna
                // sedasi on v�iksem t�en�osus, et s�nkroniseerimine mitmekordselt
                // k�ivitatakse
                params.setLastAarSync(new Date());
                params.saveToDB(this.dbConn);

                // S�nkroniseerime kohaliku asutuste ja �iguste andmebaasi andmeid
                // keskse �iguste andmekoguga
                Asutus.runAarSyncronization(dbConn);
            }            
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "run");
        } finally {
            CommonMethods.closeConnectionSafely(this.dbConn);
        }
    }
}
