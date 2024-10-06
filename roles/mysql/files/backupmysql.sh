#!/bin/sh
# 他のユーザからバックアップを読み込めないようにする

umask 077

# バックアップファイルを何日分残しておく（5日）
period=5
# バックアップファイルを保存するディレクトリ
dirpath='/var/backup/mysql'

# ファイル名を定義(※ファイル名で日付がわかるようにしておきます)
filename=`date +%y%m%d`

# パスワードファイル読み込み
source /var/backup/db_password.cnf

# mysqldump実行（ファイルサイズ圧縮の為gzで圧縮しておきます。）
# mysqldump --defaults-extra-file=/var/backup/mysql-dbaccess.cnf | gzip > $dirpath/$filename.sql.gz
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PWD" "$MYSQL_DB" | gzip > $dirpath/$filename.sql.gz

# 古いバックアップファイルを削除
oldfile=`date --date "$period days ago" +%y%m%d`
rm -f $dirpath/$oldfile.sql.gz
