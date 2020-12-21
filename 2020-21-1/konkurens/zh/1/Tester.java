import com.sun.deploy.util.StringUtils;
import my.Logger;

import java.util.concurrent.ThreadLocalRandom;

public class Tester
{
    private static final char[] arr = "abcdefghijklmnopqrstuvwxyz".toCharArray();

    public static void main(String[] args)
    {
        Logger logger = new Logger();
        for(char c : arr)
            new Thread(new ABCLog(c, logger)).start();

    }
}

class ABCLog implements Runnable
{
    private char character;
    private Logger logger;

    public ABCLog(char character, Logger logger)
    {
        this.character = character;
        this.logger = logger;
    }

    @Override
    public void run()
    {
        for (int i = 0; i < 100; i++)
        {
            logger.log(new String[]{getText()});
            try {
                Thread.sleep(getRand(0,9));
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }

    private String getText()
    {
        StringBuilder build = new StringBuilder();
        for (int i = 0; i < 20; i++) build.append(character);
        return build.toString();
    }

    private long getRand(int min, int max)
    {
        return Math.round((max - min) * Math.random()) + min;
    }
}
