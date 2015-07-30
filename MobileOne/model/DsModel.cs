using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using IBatisNet.Common;
using IBatisNet.DataMapper;

namespace MobileOne.model
{
    abstract public class DsModel
    {
        protected ISqlMapper mapper = null;


        public DsModel()
        {
            try
            {
                mapper = Mapper.Instance();
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
                throw ie;
            }
        }


    }
}
