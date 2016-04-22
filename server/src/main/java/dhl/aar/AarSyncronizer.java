package dhl.aar;

import dhl.CoreServices;
import dhl.sys.ApplicationParams;
import dhl.users.Asutus;
import dvk.core.CommonMethods;

import java.sql.Connection;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

public class AarSyncronizer implements Runnable {
    static Logger logger = Logger.getLogger(AarSyncronizer.class);

    Thread t;
    Connection dbConn;
    int syncDelay = 0;

    public void init(Connection conn, int syncDelay) {
        try {
            this.t = new Thread(this);
            this.dbConn = conn;
            this.syncDelay = syncDelay;

            // Vigaste seadetega threadi käima ei tõmba
            if ((this.dbConn != null) && (this.syncDelay > 0)) {
                this.t.start();
            } else {
                logger.error("Could not start \"aar\" database synchronizer due to incorrect settings!");
                CommonMethods.safeCloseDatabaseConnection(this.dbConn);
            }
        } catch (Exception ex) {
            logger.error(ex);
            CommonMethods.safeCloseDatabaseConnection(this.dbConn);
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
                markerDate = calendar.getTime();
            }

            Calendar now = Calendar.getInstance();
            now.setTime(new Date());
            Calendar currentSync = Calendar.getInstance();
            currentSync.setTime(markerDate);

            // Kui praegune hetk on hilisem planeeritud sünkroniseerimise ajast,
            // siis käivitame sünkroniseerimise
            if (now.after(currentSync)) {
                // Märgime seadetesse viimase sünkroniseerimise kuupäevaks
                // praeguse hetke.
                // Teeme seda igaks juhuks enne realset sünkroniseerimist, kuna
                // sedasi on väiksem tõenäosus, et sünkroniseerimine
                // mitmekordselt käivitatakse.
                params.setLastAarSync(new Date());
                params.saveToDB(this.dbConn);

                // Sünkroniseerime kohaliku asutuste ja õiguste andmebaasi
                // andmeid keskse õiguste andmekoguga
                Asutus.runAarSyncronization(dbConn);
            }
        } catch (Exception ex) {
            logger.error(ex);
        } finally {
            CommonMethods.safeCloseDatabaseConnection(this.dbConn);
        }
    }
}
