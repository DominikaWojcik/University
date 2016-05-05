using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lista_7
{
    class UserListaPanel : Panel, ISubscriber<TreeNodeMouseClickEventArgs>
    {
        public void HandleNotification(TreeNodeMouseClickEventArgs Notification)
        {
            string text = Notification.Node.Text;
            if (text.Equals("Students") || text.Equals("Teachers"))
            {
                this.Visible = true;
            }
            else
            {
                this.Visible = false;
            }
        }
    }
}
