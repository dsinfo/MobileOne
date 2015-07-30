using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using MobileOneTest.vo.bas;

namespace MobileOneTest.model.bas
{
    public class UserModel : MobileOneTest.model.DsModel
    {
        MobileOneTest.vo.bas.User vo;

        public UserModel()
        {
            vo = new User();
        }

        public bool SqlInsert(MobileOneTest.vo.bas.User vo) 
        {
            return true;
        }

        public bool SqlUpdate(MobileOneTest.vo.bas.User vo)
        {
            return true;
        }


        public bool SqlDelete(MobileOneTest.vo.bas.User vo)
        {
            return true;
        }


        public bool SqlSelect(MobileOneTest.vo.bas.User vo)
        {
            return true;
        }


        public User SqlFind(int id)
        {
            vo.Id = id;
            vo.Name = mapper.QueryForObject<string>("BAS.FindUser", id);

            return vo;
        }

    }
}