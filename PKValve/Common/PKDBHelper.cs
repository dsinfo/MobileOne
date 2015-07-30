using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

using TheOne.Data;
using TheOne.Data.SqlClient;

namespace PKMobileWeb
{
    public static class PKDBHelper
    {
        public static string ConnectString = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("/PKMobileWeb").ConnectionStrings.ConnectionStrings["PKDB"].ToString();

        #region SQL 미지정 파라미터 자동셋팅

        public static void SqlAddParam(SqlParamCollection pCols, string parameterName, System.Data.SqlDbType dbType, dynamic defaultVal, dynamic elementValue)
        {
            pCols.Add(parameterName, dbType, elementValue == null ? defaultVal : elementValue);
        }

        public static void SqlAddParam(SqlParamCollection pCols, string parameterName, System.Data.SqlDbType dbType, int size, dynamic defaultVal, dynamic elementValue)
        {
            pCols.Add(parameterName, dbType, size, elementValue == null ? defaultVal : elementValue);
        }

        public static void SqlAddParam(SqlParamCollection pCols, string parameterName, System.Data.SqlDbType dbType, int size, System.Data.ParameterDirection direction, dynamic defaultVal, dynamic elementValue)
        {
            pCols.Add(parameterName, dbType, size, direction, elementValue == null ? defaultVal : elementValue);
        }

        #endregion
    }

    public class RunStatus
    {

        //생성자
        public RunStatus()
        {
            status = true;
            msgid = "";
            lngcd = "";
            msgtype = "";
            msgtext = "";
            rtnValue = "";
            //dt = DateTime.Now; datetime test

        }
        public bool status { get; set; }
        public string msgid { get; set; }
        public string msgtype { get; set; }
        public string lngcd { get; set; }
        public string msgtext { get; set; }
        public string rtnValue { get; set; }

    }
}