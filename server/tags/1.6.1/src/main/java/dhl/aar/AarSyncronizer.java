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
            
            // Vigaste seadetega threadi kõima ei tõmba
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
            
            // Kui praegune hetk on hilisem planeeritud sõnkroniseerimise ajast,
            // siis kõivitame sõnkroniseerimise
            if (now.after(currentSync)) {
                // Mõrgime seadetesse viimase sõnkroniseerimise kuupõevaks
                // praeguse hetke.
                // Teeme seda igaks juhuks enne realset sõnkroniseerimist, kuna
                // sedasi on võiksem tõenõosus, et sõnkroniseerimine mitmekordselt
                // kõivitatakse
                params.setLastAarSync(new Date());
                params.saveToDB(this.dbConn);

                // Sõnkroniseerime kohaliku asutuste ja õiguste andmebaasi andmeid
                // keskse õiguste andmekoguga
                Asutus.runAarSyncronization(dbConn);
            }            
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "run");
        } finally {
            CommonMethods.closeConnectionSafely(this.dbConn);
        }
    }
}
