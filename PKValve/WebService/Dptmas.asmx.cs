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
    public class Dptmas : System.Web.Services.WebService
    {      

        [WebMethod]
        public string GetOrganization(string dptcd)
        {

            dptmas dept = new dptmas();
            dept.rmode = "SLT";

            return execute(dept);
         
        }

        private string execute(dptmas d)
        {
            SqlDbAccess dbAccess = new SqlDbAccess(PKDBHelper.ConnectString);
            string jsonset = string.Empty;

            if (("{SLT}").IndexOf("{" + d.rmode + "}") >= 0)
            {
                string query = @"MBL_DPTMAS_M1";
                SqlParamCollection parameters = new SqlParamCollection();

                PKDBHelper.SqlAddParam(parameters, "@INFDS", SqlDbType.VarChar, 100, d.infds);
                PKDBHelper.SqlAddParam(parameters, "@RTNCD", SqlDbType.VarChar, 100, d.rtncd);
                PKDBHelper.SqlAddParam(parameters, "@RMODE", SqlDbType.VarChar, 20, d.rmode);
                PKDBHelper.SqlAddParam(parameters, "@DPTCD", SqlDbType.VarChar, 10, d.dptcd);  

                DataTable  dt = dbAccess.ExecuteSpDataSet(query, parameters).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if(dt.Rows[i]["HPTEL"].ToString().Trim()!=string.Empty)
                        {
                            dt.Rows[i]["HPTEL"] = CryptoHelper.DecryptText(dt.Rows[i]["HPTEL"].ToString().Trim());
                        }

                        if (dt.Rows[i]["EMAIL"].ToString().Trim() != string.Empty)
                        {
                            dt.Rows[i]["EMAIL"] = CryptoHelper.DecryptText(dt.Rows[i]["EMAIL"].ToString().Trim());
                        }

                        if (dt.Rows[i]["TELNO"].ToString().Trim() != string.Empty)
                        {
                            dt.Rows[i]["TELNO"] = CryptoHelper.DecryptText(dt.Rows[i]["TELNO"].ToString().Trim());
                        }

                        //if (dt.Rows[i]["GNAME"].ToString().Trim() != string.Empty)
                        //{
                        //    dt.Rows[i]["GNAME"] = "XXX"; //dt.Rows[i]["GNAME"].ToString().Trim().Replace('(', 'X').Replace(')', 'Y');
                        //}
                    }

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

    public class dptmas
    {
        public dptmas()
        {
            this.infds = "";
            this.rtncd = "";
            this.rmode = "";
            this.dptcd = "";            
        }

      
        public string infds { get; set; }      
        public string rtncd { get; set; }     
        public string rmode { get; set; }      
        public string dptcd { get; set; }             

    }
}
