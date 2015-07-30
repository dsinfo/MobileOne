using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using TheOne.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;
using TheOne.Security;

namespace PKMobileWeb.WebService
{
    /// <summary>
    /// Momast의 요약 설명입니다.
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // ASP.NET AJAX를 사용하여 스크립트에서 이 웹 서비스를 호출하려면 다음 줄의 주석 처리를 제거합니다. 
    [System.Web.Script.Services.ScriptService]
    public class Salsum : System.Web.Services.WebService
    {      

        [WebMethod]
        public string GetDailySaleReport(string tdate)
        {

            salsum sal = new salsum();
            sal.tdate = tdate;
            sal.slttg = "RPT01";
            sal.rmode = "SLT";

            return execute(sal);
         
        }

        [WebMethod]
        public string GetDeliveryLoad(string tdate)
        {

            salsum sal = new salsum();
            sal.tdate = tdate;
            sal.slttg = "RPT02";
            sal.rmode = "SLT";

            return execute(sal);

        }

        [WebMethod]
        public string GetProductionLoad(string tdate)
        {

            salsum sal = new salsum();
            sal.tdate = tdate;
            sal.slttg = "RPT07";
            sal.rmode = "SLT";

            return execute(sal);

        }

        [WebMethod]
        public string GetDailyOrderReport(string tdate)
        {

            salsum sal = new salsum();
            sal.tdate = tdate;            
            sal.rmode = "SLT2";

            return execute(sal);

        }

        private string execute(salsum s)
        {
            SqlDbAccess dbAccess = new SqlDbAccess(PKDBHelper.ConnectString);
            dbAccess.CommandTimeout = 120;
            string jsonset = string.Empty;

            if (("{SLT}{SLT2}{SLT3}").IndexOf("{" + s.rmode + "}") >= 0)
            {
                string query = @"MBL_SALSUM_Q1";
                SqlParamCollection parameters = new SqlParamCollection();

                PKDBHelper.SqlAddParam(parameters, "@INFDS", SqlDbType.VarChar, 100, s.infds);
                PKDBHelper.SqlAddParam(parameters, "@RTNCD", SqlDbType.VarChar, 100, s.rtncd);
                PKDBHelper.SqlAddParam(parameters, "@RMODE", SqlDbType.VarChar, 20, s.rmode);
                PKDBHelper.SqlAddParam(parameters, "@TDATE", SqlDbType.VarChar, 8, s.tdate);
                PKDBHelper.SqlAddParam(parameters, "@SLTTG", SqlDbType.VarChar, 10, s.slttg);  

                DataTable  dt = dbAccess.ExecuteSpDataSet(query, parameters).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(dt); //, Formatting.Indented);                  
                }
                else
                {
                    return string.Empty;
                }
            }
            else
            {
                return string.Empty;
            }
        }
    }

    public class salsum
    {
        public salsum()
        {
            this.infds = "";
            this.rtncd = "";
            this.rmode = "";
            this.tdate = "";
            this.slttg = "";
        }

      
        public string infds { get; set; }      
        public string rtncd { get; set; }     
        public string rmode { get; set; }      
        public string tdate { get; set; }
        public string slttg { get; set; }

    }
}
