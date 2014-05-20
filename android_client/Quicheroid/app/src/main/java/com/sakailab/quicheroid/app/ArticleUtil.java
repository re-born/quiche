package com.sakailab.quicheroid.app;

/**
 * Created by taisho6339 on 2014/05/21.
 */
public class ArticleUtil {

    private final static String HTTP_LABEL = "http";

    private ArticleUtil() {
    }


    public static String getURLString(String text) {
        boolean isHttp = text.startsWith(HTTP_LABEL);
        if (!isHttp)
            return "";

        int index = text.indexOf(HTTP_LABEL);
        return text.substring(index);
    }


}
