using System;
using System.Web;

/*
 * @date   2015.07.29
 * @author kb.shin
 * @desc   사용자 VO객체
 * @update 2015.07.29
 *           - 최초생성
 *         
 */
namespace MobileOne.model.bas
{
    public class EsaUserVO 
    {
        public string msg_ID { get; set; }
        public string msg_NM { get; set; }

        public string usr_ID { get; set; }
        public string usr_NM { get; set; }    
        public string usr_En_NM { get; set; }    
        public string dept_CD { get; set; }    
        public string plant_CD { get; set; }    
    }
}
