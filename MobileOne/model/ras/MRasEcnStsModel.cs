using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobileOne.model.ras
{
    public class MRasEcnStsModel : MobileOne.model.DsModel
    {
        private MRasEcnStsVO vo = new MRasEcnStsVO();

        public MRasEcnStsModel() 
        {
           // base();
        }


        /*=================================================================
         * 데이터 입력/수정/삭제 및 조회
         * ===============================================================*/
        // 품번 조회, 리턴값이 품명임 
        public MRasEcnStsVO SqlFind(String eq_cd)
        {
            try
            {
                vo.eq_cd = eq_cd;

                vo = mapper.QueryForObject<MRasEcnStsVO>("RAS.MRasEcnSts_FIND", vo);

                return vo;
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                return null;
            }

        }

        public System.Collections.IList SqlSelect(String work_date)
        {
            try
            {
                System.Collections.IList voList = null;

                voList = mapper.QueryForList("RAS.MRasEcnSts_SELECT", vo);
                return voList;
            }
            catch (Exception ie)
            {
                throw ie;
            }
        }

    }
}
