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
    public class Usrmas : System.Web.Services.WebService
    {
        [WebMethod]
        public string Login(string userid, string password)
        {
            
            usrmas user = new usrmas();
            user.usrid = userid;
            user.paswd = password;
            user.rmode = "CHKUSR";
            user.ipadr = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];//HttpContext.Current.Request.UserHostAddress;


            return execute(user);
        }

        [WebMethod]
        public string GetLoghistory(string fdate, string tdate)
        {

            usrmas user = new usrmas();
            user.fdate = fdate;
            user.tdate = tdate;
            user.rmode = "SLT";
            
            return execute(user);
        }

        [WebMethod]
        public string CheckAuth(string userid, string ssnid, string frmnm)
        {

            usrmas user = new usrmas();
            user.usrid = userid;
            user.ssnid = ssnid;
            user.frmnm = frmnm;
            user.rmode = "CHKAUTH";

            return execute(user);
        }



        private string execute(usrmas p)
        {
            SqlDbAccess dbAccess = new SqlDbAccess(PKDBHelper.ConnectString);
            string jsonset = string.Empty;

            if (("{CHKUSR}{CHKAUTH}{SLT}").IndexOf("{" + p.rmode + "}") >= 0)
            {
                string query = @"MBL_USRMAS_M1";
                SqlParamCollection parameters = new SqlParamCollection();

                PKDBHelper.SqlAddParam(parameters, "@INFDS", SqlDbType.VarChar, 100, p.infds);
                PKDBHelper.SqlAddParam(parameters, "@RTNCD", SqlDbType.VarChar, 100, p.rtncd);
                PKDBHelper.SqlAddParam(parameters, "@RMODE", SqlDbType.VarChar, 20, p.rmode);
                PKDBHelper.SqlAddParam(parameters, "@USRID", SqlDbType.VarChar, 10, p.usrid);
                PKDBHelper.SqlAddParam(parameters, "@PASWD", SqlDbType.VarChar, 10, p.paswd);
                PKDBHelper.SqlAddParam(parameters, "@IPADR", SqlDbType.VarChar, 20, p.ipadr);
                PKDBHelper.SqlAddParam(parameters, "@FDATE", SqlDbType.Char, 8, p.fdate);
                PKDBHelper.SqlAddParam(parameters, "@TDATE", SqlDbType.Char, 8, p.tdate);
                PKDBHelper.SqlAddParam(parameters, "@SSNID", SqlDbType.VarChar, 50, p.ssnid);
                PKDBHelper.SqlAddParam(parameters, "@FRMNM", SqlDbType.VarChar, 100, p.frmnm);

                //PKDBHelper.SqlAddParam(parameters, "@DPTCD", SqlDbType.Char, 20, p.dptcd);
                //PKDBHelper.SqlAddParam(parameters, "@USEYN", SqlDbType.Char, 1, p.useyn);             

                DataTable  dt = dbAccess.ExecuteSpDataSet(query, parameters).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(dt, Formatting.Indented);  
                        
                    //if (dt.Rows[0]["RESULT"].ToString() == "OK")
                    //{
                    //    return "OK";
                    //}
                    //else
                    //{
                    //    if (dt.Rows[0]["MSGID"].ToString() == "ERR0008")
                    //    {
                    //        return "ERR_USER";
                    //        //PKMessageBox.ShowError("사용자가 등록되어 있지 않습니다!", DialogButtons.Ok, "로그인 에러");                       
                    //    }
                    //    else
                    //    {
                    //        return "ERR_PWD";
                    //        //PKMessageBox.ShowError("비밀번호를 다시 입력하세요!", DialogButtons.Ok, "로그인 에러");

                    //    }
                    //}
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

    public class usrmas
    {
        public usrmas()
        {
            this.infds = "";
            this.rtncd = "";
            this.rmode = "";
            this.usrid = "";
            this.paswd = "";
            this.cfmpw = "";
            this.oldpw = "";
            this.ipadr = "";
            this.fdate = "";
            this.tdate = "";
            this.ssnid = "";
            this.frmnm = "";
        }

      
        public string infds { get; set; }      
        public string rtncd { get; set; }     
        public string rmode { get; set; }      
        public string usrid { get; set; }     
        public string paswd { get; set; }    
        public string cfmpw { get; set; }      
        public string oldpw { get; set; }
        public string ipadr { get; set; }
        public string fdate { get; set; }
        public string tdate { get; set; }
        public string ssnid { get; set; }
        public string frmnm { get; set; }

    }
}
