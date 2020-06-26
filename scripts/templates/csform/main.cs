using System;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace HelloForm
{
    class Program
    {
        [STAThread]
        public static void Main()
        {
            Application.EnableVisualStyles();
            Application.Run(new Form1());
        }
    }

    public class Form1 : Form
    {
        public Button Button1;

        public Form1()
        {
            Button1 = new Button();
            Button1.Size = new Size(40, 40);
            Button1.Location = new Point(30, 30);
            Button1.Text = "Click Me";
            this.Controls.Add(Button1);
            Button1.Click += new EventHandler(Button1_Click);
        }

        private void Button1_Click(object sender, EventArgs eventArgs)
        {
            MessageBox.Show("Hello World");
        }
    }
}