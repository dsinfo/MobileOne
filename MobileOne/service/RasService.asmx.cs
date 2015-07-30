using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

using Newtonsoft.Json;

using MobileOne.model.ras;



namespace MobileOne.service
{
    /// <summary>
    /// Hello의 요약 설명입니다.
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // ASP.NET AJAX를 사용하여 스크립트에서 이 웹 서비스를 호출하려면 다음 줄의 주석 처리를 제거합니다. 
    [System.Web.Script.Services.ScriptService]



    public class RasService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }


        /*

        [WebMethod]
        public string Find(string eqcd)
        {

            MRasEcnStsModel model = new MRasEcnStsModel();

            MobileOne.model.ras.MRasEcnStsVO vo = model.SqlFind(eqcd);

            return JsonConvert.SerializeObject(vo);
        }
        */


        [WebMethod]
        public string Select(string workdate)
        {
            MRasEcnStsModel model = new MRasEcnStsModel();

            System.Collections.IList voList = model.SqlSelect(workdate);
            return JsonConvert.SerializeObject(voList);
        }


    }
}
