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
    public class Momast : System.Web.Services.WebService
    {
        
        // 작업지시정보 가져오기 
        [WebMethod]
        public string GetOrderInfomation(string ordno)
        {
            momast morder = new momast();
            morder.rmode = "SLT";
            morder.ordno = ordno;

            return execute(morder);
        }

        // 작업지시정보 가져오기 
        [WebMethod]
        public string GetOrders(string ordno)
        {
            momast morder = new momast();
            morder.rmode = "SLT2";
            morder.ordno = ordno;

            return execute(morder);
        }
        // 작업지시할당품목정보 가져오기 
        [WebMethod]
        public string GetOrderAllocateItem(string ordno)
        {
            momast morder = new momast();
            morder.rmode = "SLT3";
            morder.ordno = ordno;

            return execute(morder);
        }


        // 작업지시공정정보 가져오기 
        [WebMethod]
        public string GetOrderProcess(string ordno)
        {
            momast morder = new momast();
            morder.rmode = "SLT4";
            morder.ordno = ordno;

            return execute(morder);
        }

        // 작업지시공정정보 가져오기(챠트) 
        [WebMethod]
        public string GetOrderProcessChart(string ordno)
        {
            momast morder = new momast();
            morder.rmode = "SLT5";
            morder.ordno = ordno;

            return execute(morder);
        }

        // 작업지시공정정보 가져오기(챠트) 
        [WebMethod]
        public string GetDailyProduction(string fdate, string tdate)
        {
            momast morder = new momast();
            morder.rmode = "SLT6";
            morder.fdate = fdate;
            morder.tdate = tdate;

            return execute(morder);
        }

        /// <summary>
        /// 지시정보 
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        private string execute(momast m)
        {
            SqlDbAccess dbAccess = new SqlDbAccess(PKDBHelper.ConnectString);
            dbAccess.CommandTimeout = 120;
            string jsonset = string.Empty;

            if (("{SLT},{SLT2},{SLT3},{SLT4}{SLT5}{SLT6}").IndexOf("{" + m.rmode + "}") >= 0)
            {
                string query = @"MBL_MOMAST_Q1";
                SqlParamCollection parameters = new SqlParamCollection();

                PKDBHelper.SqlAddParam(parameters, "@INFDS", SqlDbType.VarChar, 100, m.infds);
                PKDBHelper.SqlAddParam(parameters, "@RTNCD", SqlDbType.VarChar, 100, m.rtncd);
                PKDBHelper.SqlAddParam(parameters, "@RMODE", SqlDbType.VarChar, 20, m.rmode);
                PKDBHelper.SqlAddParam(parameters, "@ORDNO", SqlDbType.VarChar, 20, m.ordno);
                PKDBHelper.SqlAddParam(parameters, "@FDATE", SqlDbType.Char, 8, m.fdate);
                PKDBHelper.SqlAddParam(parameters, "@TDATE", SqlDbType.Char, 8, m.tdate);
                            

                DataTable dt = dbAccess.ExecuteSpDataSet(query, parameters).Tables[0];

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

    public class momast
    {
        public momast()
        {
            this.infds = "";
            this.rtncd = "";
            this.rmode = "";
            this.ordno = "";
            this.fdate = "";
            this.tdate = "";
        }

        public string infds { get; set; }
        public string rtncd { get; set; }
        public string rmode { get; set; }
        public string ordno { get; set; }
        public string fdate { get; set; }
        public string tdate { get; set; }

    }
}
