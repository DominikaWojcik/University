using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lista_7
{
    class SubscriberDataGrid : DataGridView, ISubscriber<TreeNodeMouseClickEventArgs>
    {
        public void HandleNotification(TreeNodeMouseClickEventArgs Notification)
        {
            string text = Notification.Node.Text;
            switch(text)
            {
                case "Students":
                    Populator.PopulateDataGrid(this, DataBank.Instance.GetUsers(UserType.Student));
                    break;
                case "Teachers":
                    Populator.PopulateDataGrid(this, DataBank.Instance.GetUsers(UserType.Teacher));
                    break;
                default:
                    string[] info = text.Split();
                    Populator.PopulateDataGrid(this, DataBank.Instance.GetUsers(
                        delegate(User u)
                        { 
                            return u.Name.Equals(info[1]) && u.LastName.Equals(info[0]); 
                        }));
                    break;
            }
        }
    }
}
