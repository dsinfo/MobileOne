using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using TheOne.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;


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
    public class Pgmmas : System.Web.Services.WebService
    {      

        [WebMethod]
        public string GetMenu(string usrid)
        {
           
            pgmmas pgm = new pgmmas();
            pgm.usrid = usrid;
            pgm.usrty = "E";
            pgm.syscd = "MBL";
            pgm.ismbl = "1";
            pgm.rmode = "SLT";

            return execute(pgm);
         
        }

        private string execute(pgmmas p)
        {
            SqlDbAccess dbAccess = new SqlDbAccess(PKDBHelper.ConnectString);
            string jsonset = string.Empty;

            if (("{SLT}").IndexOf("{" + p.rmode + "}") >= 0)
            {
                string query = @"SYS_PGMMAS_Q1";
                SqlParamCollection parameters = new SqlParamCollection();

                PKDBHelper.SqlAddParam(parameters, "@INFDS", SqlDbType.VarChar, 100, p.infds);
                PKDBHelper.SqlAddParam(parameters, "@RTNCD", SqlDbType.VarChar, 100, p.rtncd);
                PKDBHelper.SqlAddParam(parameters, "@RMODE", SqlDbType.VarChar, 20, p.rmode);
                PKDBHelper.SqlAddParam(parameters, "@USRID", SqlDbType.VarChar, 10, p.usrid);
                PKDBHelper.SqlAddParam(parameters, "@USRTY", SqlDbType.VarChar, 10, p.usrty);
                PKDBHelper.SqlAddParam(parameters, "@SYSCD", SqlDbType.VarChar, 20, p.syscd);
                PKDBHelper.SqlAddParam(parameters, "@ISMBL", SqlDbType.VarChar, 1, p.ismbl);

                DataTable  dt = dbAccess.ExecuteSpDataSet(query, parameters).Tables[0];

                if (dt.Rows.Count > 0)
                {  
                    return JsonConvert.SerializeObject(dt, Formatting.Indented);                  
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

    public class pgmmas
    {
        public pgmmas()
        {
            this.infds = "";
            this.rtncd = "";
            this.rmode = "";
            this.usrid = "";
            this.usrty = "";
            this.pgmid = 0;
            this.pgmsq = 0;
            this.pgmtp = "";
            this.pgmnm = "";
            this.syscd = "";
            this.asbnm = "";
            this.frmnm = "";
            this.ismbl = "";
        }

      
        public string infds { get; set; }      
        public string rtncd { get; set; }     
        public string rmode { get; set; }      
        public string usrid { get; set; }     
        public string usrty { get; set; }    
        public int pgmid { get; set; }      
        public int pgmsq { get; set; }
        public string pgmtp { get; set; }
        public string pgmnm { get; set; }
        public string syscd { get; set; }
        public string asbnm { get; set; }
        public string frmnm { get; set; }
        public string ismbl { get; set; }

    }
}
