using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lista_7
{
    public partial class KrtkPanel : Component
    {
        public KrtkPanel()
        {
            InitializeComponent();
        }

        public KrtkPanel(IContainer container)
        {
            container.Add(this);

            InitializeComponent();
        }
    }
}
