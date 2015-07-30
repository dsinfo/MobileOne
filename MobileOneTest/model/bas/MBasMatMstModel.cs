using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MobileOneTest.vo.bas;

namespace MobileOneTest.model.bas
{
    public class MBasMatMstModel : MobileOneTest.model.DsModel
    {
        private MBasMatMstVO vo = new MBasMatMstVO();

        public MBasMatMstModel() 
        {
           // base();
        }


        /*=================================================================
         * 데이터 입력/수정/삭제 및 조회
         * ===============================================================*/

        // 품번 조회, 리턴값이 품명임 
        public MBasMatMstVO SqlFind(String mat_cd)
        {
            try
            {
                vo.Mat_CD = mat_cd;

                vo = mapper.QueryForObject<MBasMatMstVO>("BAS.MBasMatMst_FIND", vo);

                return vo;
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                return null;
            }

        }

        public String SqlFindString(String mat_cd)
        {
            try
            {
                String mat_nm = mapper.QueryForObject<String>("BAS.FindMat", mat_cd);

                return mat_nm;
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                return "test";
            }

        }

        public System.Collections.IList SqlFindList(String mat_cd)
        {
            try
            {
                vo.Mat_CD = mat_cd;

                return mapper.QueryForList("BAS.MBasMatMst_SELECT", vo);
            }
            catch (Exception ie)
            {
                throw ie;
            }
        }
    }
}
