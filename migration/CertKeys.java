// Forked from u/bjlunden - https://gist.github.com/gmrt/4c2f883d171b62f6756b4c5d2b39927f
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;

public class CertKeys {

    // frameworks/base/core/java/android/content/pm/Signature.java
    private static String signatureToCharString(byte[] sig) {
        final int N = sig.length;
        final int N2 = N*2;
        char[] text = new char[N2];
        for (int j=0; j<N; j++) {
            byte v = sig[j];
            int d = (v>>4)&0xf;
            text[j*2] = (char)(d >= 10 ? ('a' + d - 10) : ('0' + d));
            d = v&0xf;
            text[j*2+1] = (char)(d >= 10 ? ('a' + d - 10) : ('0' + d));
        }
        return new String(text);
    }

    public static void main(String[] args) throws FileNotFoundException, CertificateException {
        if (args.length < 1) {
            System.out.println("You must specify the path to certificate.x509.pem");
            System.exit(1);
        }

        FileInputStream fis = new FileInputStream(args[0]);
        BufferedInputStream bis = new BufferedInputStream(fis);

        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        Certificate cert = cf.generateCertificate(bis);
        byte[] signature = cert.getEncoded();

        System.out.println(signatureToCharString(signature));
    }
}
