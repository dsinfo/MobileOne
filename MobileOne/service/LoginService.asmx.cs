using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;

using MobileOne.model.bas;
using Newtonsoft.Json;

namespace MobileONE.service
{
    /// <summary>
    /// LoginService의 요약 설명입니다.
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    
    
    // ASP.NET AJAX를 사용하여 스크립트에서 이 웹 서비스를 호출하려면 다음 줄의 주석 처리를 제거합니다. 
    [System.Web.Script.Services.ScriptService]
    public class LoginService : System.Web.Services.WebService
    {
        public LoginService()
        {
            //DSWebService dsws = new DSWebService();
            //dsws.DSInit();
        }

        [WebMethod]
        public string Login(string userid, string password)
        {
            EsaUserModel model = new EsaUserModel();

            // 사원 id로 사원을 검색한다.
            EsaUserVO vo = model.SqlFind(userid);

            if (vo != null) {
                if (model.IsPasswordEqual(password)) {
                    vo.msg_ID = "OK";
                }
                else {
                    vo.msg_ID = "ERR0009";
                    vo.msg_NM = "패스워드가 일치하지 않습니다";
                }
            } else {
                vo = new EsaUserVO();

                vo.msg_ID = "ERR0008";
                vo.msg_NM = "사용자를 찾을 수 없습니다";
            }

            return JsonConvert.SerializeObject(vo);
        }


        [WebMethod]
        public string GetMenu(string userid)
        {
            EsaMenuModel model = new EsaMenuModel();

            System.Collections.IList voList = model.SqlSelect(userid);
            return JsonConvert.SerializeObject(voList);
        }

    }
}
