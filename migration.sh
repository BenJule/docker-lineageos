script_path="/build/migration/META-INF/com/google/android/update-binary"
cd /build/migration
javac CertKeys.java

for i in media platform shared; do
        cert_path="/build/android-certs/${i}.x509.pem"
        cert_file="$(java CertKeys ${cert_path})"
        key_file="$(openssl x509 -pubkey -noout -in ${cert_path} | grep -v '-' | tr -d '\n' | paste)"
        sed -i "s#${i}_cert_release=.*#${i}_cert_release='${cert_file}'#g" $script_path
        sed -i "s#${i}_key_release=.*#${i}_key_release='${key_file}'#g" $script_path
done

cert_path="/build/android-certs/releasekey.x509.pem"
cert_file="$(java CertKeys ${cert_path})"
key_file="$(openssl x509 -pubkey -noout -in ${cert_path} | grep -v '-' | tr -d '\n' | paste)"
sed -i "s#release_cert=.*#release_cert='${cert_file}'#g" $script_path
sed -i "s#release_key=.*#release_key='${key_file}'#g" $script_path

zip -r9 /tmp/migration.zip /build/migration/META-INF
java -jar /build/android/prebuilts/sdk/tools/lib/signapk.jar \
    /build/android-certs/releasekey.x509.pem \
    /build/android-certs/releasekey.pk8 \
    /tmp/migration.zip \
    /build/zips/migration.zip

rm /tmp/migration.zip
rm CertKeys.class # Clean up
