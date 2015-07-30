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
    public class EsaUserModel : MobileOne.model.DsModel
    {
        private EsaUserVO vo = new EsaUserVO();


        public EsaUserModel() 
        {
        }


        /*=================================================================
         * 데이터 입력/수정/삭제 및 조회
         * ===============================================================*/
        // 사용자id를 이용하여 사원정보를 검색함.
        public EsaUserVO SqlFind(String usr_ID)
        {
            try
            {
                vo.usr_ID = usr_ID;
                vo = mapper.QueryForObject<EsaUserVO>("BAS.EsaUser_FIND", vo);
                return vo;
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                return null;
            }
        }

        public bool IsPasswordEqual(String pw)
        {
            return true;
        }

   }
}
