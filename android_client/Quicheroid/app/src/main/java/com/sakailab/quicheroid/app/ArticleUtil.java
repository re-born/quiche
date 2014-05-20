package com.sakailab.quicheroid.app;

/**
 * Created by taisho6339 on 2014/05/21.
 */
public class ArticleUtil {

    private final static String HTTP_LABEL = "http://";
    private final static String HTTPS_LABEL = "https://";

    private ArticleUtil() {
    }

    public static boolean isHttpUrl(String text) {
        return text.contains(HTTP_LABEL);
    }

    public static boolean isHttpsUrl(String text) {
        return text.contains(HTTPS_LABEL);
    }

    public static String getURLString(String text) {
        int index = text.indexOf(HTTP_LABEL);
        if (index < 0)
            index = text.indexOf(HTTPS_LABEL);
        return text.substring(index);
    }


}
