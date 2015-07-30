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
    public class EsaMenuVO 
    {
        public string msg_ID { get; set; }
        public string msg_NM { get; set; }

        public string usr_ID  { get; set; }
        public string menu_ID { get; set; }
        public string menu_NM { get; set; }
        public string menu_url { get; set; }
        public string menu_group_ID { get; set; }
        public string menu_group_NM { get; set; }
    }
}
