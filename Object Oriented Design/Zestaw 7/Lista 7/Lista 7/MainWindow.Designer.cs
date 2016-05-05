namespace Lista_7
{
    partial class MainWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.CategoryTree = new System.Windows.Forms.TreeView();
            this.Zmien = new System.Windows.Forms.Button();
            this.UserKartotekaView = new Lista_7.SubscriberDataGrid();
            this.KartotekaPanel = new UserKartotekaPanel();
            this.Nazwisko = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Imie = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Adres = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DataUrodzenia = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ListaPanel = new UserListaPanel();
            this.UserListaView = new SubscriberDataGrid();
            this.Dodaj = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.UserKartotekaView)).BeginInit();
            this.ListaPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.UserListaView)).BeginInit();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.IsSplitterFixed = true;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.CategoryTree);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.KartotekaPanel);
            this.splitContainer1.Panel2.Controls.Add(this.ListaPanel);
            this.splitContainer1.Size = new System.Drawing.Size(836, 477);
            this.splitContainer1.SplitterDistance = 232;
            this.splitContainer1.TabIndex = 0;
            // 
            // CategoryTree
            // 
            this.CategoryTree.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.CategoryTree.Dock = System.Windows.Forms.DockStyle.Fill;
            this.CategoryTree.Location = new System.Drawing.Point(0, 0);
            this.CategoryTree.Name = "CategoryTree";
            this.CategoryTree.Size = new System.Drawing.Size(230, 475);
            this.CategoryTree.TabIndex = 0;
            this.CategoryTree.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.CategoryTree_AfterSelect);
            this.CategoryTree.NodeMouseClick += new System.Windows.Forms.TreeNodeMouseClickEventHandler(this.CategoryTree_NodeMouseClick);
            // 
            // Zmien
            // 
            this.Zmien.Location = new System.Drawing.Point(258, 441);
            this.Zmien.Name = "Zmien";
            this.Zmien.Size = new System.Drawing.Size(75, 23);
            this.Zmien.TabIndex = 1;
            this.Zmien.Text = "Zmień";
            this.Zmien.UseVisualStyleBackColor = true;
            this.Zmien.Click += new System.EventHandler(this.ZmienButton_Click);
            // 
            // UserKartotekaView
            // 
            this.UserKartotekaView.AllowUserToAddRows = false;
            this.UserKartotekaView.AllowUserToDeleteRows = false;
            this.UserKartotekaView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.UserKartotekaView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.UserKartotekaView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Nazwisko,
            this.Imie,
            this.Adres,
            this.DataUrodzenia});
            this.UserKartotekaView.Dock = System.Windows.Forms.DockStyle.Top;
            this.UserKartotekaView.Location = new System.Drawing.Point(0, 0);
            this.UserKartotekaView.Name = "UserKartotekaView";
            this.UserKartotekaView.ReadOnly = true;
            this.UserKartotekaView.Size = new System.Drawing.Size(598, 423);
            this.UserKartotekaView.TabIndex = 0;
            this.UserKartotekaView.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellContentClick_1);
            // 
            // Nazwisko
            // 
            this.Nazwisko.HeaderText = "Last Name";
            this.Nazwisko.Name = "Nazwisko";
            this.Nazwisko.ReadOnly = true;
            // 
            // Imie
            // 
            this.Imie.HeaderText = "Name";
            this.Imie.Name = "Imie";
            this.Imie.ReadOnly = true;
            // 
            // Adres
            // 
            this.Adres.HeaderText = "Address";
            this.Adres.Name = "Adres";
            this.Adres.ReadOnly = true;
            // 
            // DataUrodzenia
            // 
            this.DataUrodzenia.HeaderText = "Date Of Birth";
            this.DataUrodzenia.Name = "DataUrodzenia";
            this.DataUrodzenia.ReadOnly = true;
            // 
            // ListaPanel
            // 
            this.ListaPanel.Controls.Add(this.Dodaj);
            this.ListaPanel.Controls.Add(this.UserListaView);
            this.ListaPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ListaPanel.Location = new System.Drawing.Point(0, 0);
            this.ListaPanel.Name = "ListaPanel";
            this.ListaPanel.Size = new System.Drawing.Size(598, 475);
            this.ListaPanel.TabIndex = 0;
            this.ListaPanel.Visible = false;
            // 
            // UserListaView
            // 
            this.UserListaView.AllowUserToAddRows = false;
            this.UserListaView.AllowUserToDeleteRows = false;
            this.UserListaView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.UserListaView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.UserListaView.Dock = System.Windows.Forms.DockStyle.Top;
            this.UserListaView.Location = new System.Drawing.Point(0, 0);
            this.UserListaView.Name = "UserListaView";
            this.UserListaView.ReadOnly = true;
            this.UserListaView.Size = new System.Drawing.Size(598, 423);
            this.UserListaView.TabIndex = 0;
            
            // 
            // Dodaj
            // 
            this.Dodaj.Location = new System.Drawing.Point(266, 441);
            this.Dodaj.Name = "Dodaj";
            this.Dodaj.Size = new System.Drawing.Size(75, 23);
            this.Dodaj.TabIndex = 1;
            this.Dodaj.Text = "Dodaj";
            this.Dodaj.UseVisualStyleBackColor = true;
            this.Dodaj.Click += new System.EventHandler(this.button1_Click);
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(836, 477);
            this.Controls.Add(this.splitContainer1);
            this.Name = "MainWindow";
            this.Text = "Kartoteka";
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.UserKartotekaView)).EndInit();
            this.ListaPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.UserListaView)).EndInit();
            this.ResumeLayout(false);

        }


        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.TreeView CategoryTree;
        private UserKartotekaPanel KartotekaPanel;
        private System.Windows.Forms.Button Zmien;
        private System.Windows.Forms.DataGridViewTextBoxColumn Nazwisko;
        private System.Windows.Forms.DataGridViewTextBoxColumn Imie;
        private System.Windows.Forms.DataGridViewTextBoxColumn Adres;
        private System.Windows.Forms.DataGridViewTextBoxColumn DataUrodzenia;
        private SubscriberDataGrid UserKartotekaView;
        private System.Windows.Forms.Panel ListaPanel;
        private System.Windows.Forms.Button Dodaj;
        private SubscriberDataGrid UserListaView;

    }
}

