using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace Lista_7
{
    public partial class MainWindow : Form
    {
        public MainWindow()
        {
            InitializeComponent();

            EventAggregator.Instance.AddSubscriber(UserKartotekaView as SubscriberDataGrid);
            EventAggregator.Instance.AddSubscriber(UserListaView as SubscriberDataGrid);

            Populator.PopulateDataGrid(UserKartotekaView);
            Populator.PopulateTree(CategoryTree);
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void CategoryTree_AfterSelect(object sender, TreeViewEventArgs e)
        {
        }

        private void CategoryTree_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            EventAggregator.Instance.Publish(e);
        }


        private void KartotekaPanel_Paint(object sender, PaintEventArgs e)
        {

        }

        private void dataGridView1_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void ZmienButton_Click(object sender, EventArgs e)
        {
            EventAggregator.Instance.Publish<EventArgs>(e);
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

    }
}
