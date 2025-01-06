```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mariadb-init
data:
  init.sql: |
    USE LED_WG;
    CREATE TABLE IF NOT EXISTS users (
      u_id INT NOT NULL AUTO_INCREMENT,
      nickname VARCHAR(50) NOT NULL,
      username VARCHAR(50) NOT NULL,
      password VARCHAR(50) NOT NULL,
      email VARCHAR(50) NOT NULL,
      user_role VARCHAR(50) NOT NULL,
      PRIMARY KEY (u_id)
    );
    CREATE TABLE IF NOT EXISTS challenges_data (
      c_id INT NOT NULL AUTO_INCREMENT,
      c_title VARCHAR(50) NOT NULL,
      c_ssh VARCHAR(50),
      c_web TINYINT(1) NOT NULL,
      c_link VARCHAR(50),
      c_hint TEXT,
      c_point int,
      c_difficulty VARCHAR(50),
      c_key VARCHAR(50),
      c_text TEXT,
      c_solves int,
      PRIMARY KEY (c_id)
    );
    CREATE TABLE IF NOT EXISTS user_data (
      d_id INT NOT NULL AUTO_INCREMENT,
      d_uid INT,
      d_cid INT,
      d_time datetime,
      PRIMARY KEY (d_id),
      FOREIGN KEY (d_uid) REFERENCES users(u_id) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (d_cid) REFERENCES challenges_data(c_id) ON DELETE CASCADE ON UPDATE CASCADE);

```
