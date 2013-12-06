package dvk.client.amphora;

import dvk.core.CommonMethods;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.Calendar;
import java.util.Date;

public class Item {
    private int m_id;
    private int m_ownerID;
    private String m_name;

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setOwnerID(int ownerID) {
        this.m_ownerID = ownerID;
    }

    public int getOwnerID() {
        return m_ownerID;
    }

    public void setName(String name) {
        this.m_name = name;
    }

    public String getName() {
        return m_name;
    }

    public Item() {
        Clear();
    }

    public void Clear() {
        m_id = 0;
        m_ownerID = 0;
        m_name = "";
    }

    public int addItem(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                Timestamp now = CommonMethods.sqlDateFromDate(new Date());
                CallableStatement cs = conn.prepareCall("{call Add_Item(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

                cs.setInt(1, 15); // @item_type_ID
                cs.setInt(2, -1); // @parent_ID
                cs.setInt(3, -1); // @first_version_ID
                cs.setInt(4, -1); // @next_version_ID
                cs.setInt(5, 1); // @ordinal
                cs.setInt(6, 1); // @item_size
                cs.setInt(7, m_ownerID); // @owner_ID
                cs.setInt(8, 1); // @creator_ID
                cs.setString(9, "127.0.0.1"); // @creator_ip
                cs.setTimestamp(10, now, cal); // @create_time
                cs.setInt(11, 1); // @editor_ID
                cs.setString(12, "127.0.0.1"); // @editor_ip
                cs.setTimestamp(13, now, cal); // @edit_time
                cs.setBoolean(14, false); // @is_system
                cs.setBoolean(15, false); // @is_locked
                cs.setBoolean(16, false); // @is_deleted
                cs.setBoolean(17, false); // @is_public
                cs.setBoolean(18, false); // @is_private
                cs.setInt(19, 0); // @superuser
                cs.setString(20, m_name); // @print_name
                cs.setString(21, ""); // @upload_path
                cs.setString(22, ""); // @id_path
                cs.setBoolean(23, false); // @send_sms
                cs.setBoolean(24, false); // @send_email
                cs.setInt(25, 0); // @reminder_interval
                cs.setBoolean(26, false); // @is_internal
                cs.setInt(27, 0); // @modules_id
                cs.setInt(28, 0); // @metadata_id
                cs.setString(29, ""); // @external_id
                cs.setBoolean(30, false); // @is_edition
                cs.setBoolean(31, false); // @is_intranet
                cs.setString(32, m_name); // @public_title
                cs.registerOutParameter(33, Types.INTEGER); // @out_added_ID

                cs.executeUpdate();
                m_id = cs.getInt(33);
                cs.close();
                conn.commit();

                return m_id;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addItem");
            return 0;
        }
    }

}
