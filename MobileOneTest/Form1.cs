using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using IBatisNet.Common;
using IBatisNet.DataMapper;

using MobileOneTest.model.bas;
using MobileOneTest.vo.bas;


namespace MobileOneTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        /*
        public static List<MobileOneTest.Employee> getEmployees(MobileOneTest.Department department)
        {
            ISqlMapper mapper = EntityMapper;

            List<MobileOneTest.Employee> employees = mapper.QueryForList<MobileOneTest.Employee>("GetEmployees", department).ToList();
            return employees;
        }


        public static string FindDepartment(int deptId)
        {
            ISqlMapper mapper = EntityMapper;
            string str = mapper.QueryForObject<string>("FindDepartment", deptId);
            return str;
        }
        */


        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                UserModel userModel = new UserModel();

                User user = userModel.SqlFind(10000);

                if (user.Name != null)
                    MessageBox.Show(user.Name);
            }
            catch (Exception ie)
            {
                MessageBox.Show(ie.Message);
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            /*
            try
            {
                //Find Department
                string deptName = FindDepartment(1);
                Console.WriteLine(deptName);
                Console.Read();

                // Get Employees
                MobileOneTest.Department dep = new MobileOneTest.Department();
                dep.Id = 2;

                List<MobileOneTest.Employee> emps = getEmployees(dep);
                Console.ReadLine();

                foreach (MobileOneTest.Employee emp in emps)
                {
                    Console.WriteLine(emp.Id + "  " + emp.Name);
                }
            }
            catch (Exception ie)
            {
                MessageBox.Show(ie.Message);
            }
            */
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                MBasMatMstModel model = new MBasMatMstModel();

                MBasMatMstVO vo = model.SqlFind("GE450200108010025");

                Console.WriteLine(vo.Mat_CD);
                Console.WriteLine(vo.Mat_NM);
                Console.WriteLine(vo.Plant_CD);
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                MBasMatMstModel model = new MBasMatMstModel();

                String mat_nm = model.SqlFindString("GE450200108010025");

                Console.WriteLine(mat_nm);
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
            }

        }

        private void button5_Click(object sender, EventArgs e)
        {
            /*
            XConnection con = XConnection.ConnectDatabase("mesmgr", "mesmgr", "WMES");

            XSQL xsql = new XSQL();
            IDataReader ir = xsql.ExecuteReader("select * from mbasmatmst where mat_cd = 'GE450200108010025'");


            String nm = ir.GetString(1);

            Console.WriteLine(nm);
             */
        }

        private void button6_Click(object sender, EventArgs e)
        {
            try
            {
                //MBasMatMstModel model = new MBasMatMstModel();

                //IList<MBasMatMstVO> voList = model.SqlFindList("GE4502001080%");

                //Console.WriteLine(voList[0].Mat_CD);
                //Console.WriteLine(voList[1].Mat_CD);
            }
            catch (Exception ie)
            {
                Console.WriteLine(ie.ToString());
            }

        }
    }
}
