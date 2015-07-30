using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace PKMobileWeb
{
    public class PKPage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            //if (this.Session["user"] == null)
            //{
            //    this.Response.Redirect("Login.aspx");
            //}

            base.OnInit(e);           
        }
    }
}