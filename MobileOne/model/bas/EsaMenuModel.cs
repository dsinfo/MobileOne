using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

/*
 * @date   2015.07.29
 * @author kb.shin
 * @desc   사용자 Model 객체
 * @update 2015.07.29
 *           - 최초생성
 *         
 */

namespace MobileOne.model.bas
{
    public class EsaMenuModel : MobileOne.model.DsModel
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

 
        private EsaMenuVO vo = new EsaMenuVO();


        public EsaMenuModel() 
        {
        }


        /*=================================================================
         * 데이터 입력/수정/삭제 및 조회
         * ===============================================================*/
        // 사용자id를 이용하여 사원정보를 검색함.
        public System.Collections.IList SqlSelect(String usr_ID)
        {
            try
            {
                log.Info("call sqlselects...");

                System.Collections.IList voList = null;

                voList = mapper.QueryForList("BAS.EsaMenu_SELECT", vo);
                return voList;
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                return null;
            }
        }
   }
}
