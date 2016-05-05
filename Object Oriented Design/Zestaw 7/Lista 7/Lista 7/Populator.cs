using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lista_7
{
    public class Populator
    {
        public static void PopulateTree(TreeView tree)
        {
            tree.Nodes.Clear();

            TreeNode students = new TreeNode();
            students.Text = "Students";
            TreeNode teachers = new TreeNode();
            teachers.Text = "Teachers";

            foreach(User student in DataBank.Instance.GetUsers(UserType.Student))
            {
                TreeNode newStudent = new TreeNode(student.LastName + " " + student.Name);
                students.Nodes.Add(newStudent);
            }

            foreach(User teacher in DataBank.Instance.GetUsers(UserType.Teacher))
            {
                TreeNode newTeacher = new TreeNode(teacher.LastName + " " + teacher.Name);
                teachers.Nodes.Add(newTeacher);
            }

            tree.Nodes.Add(students);
            tree.Nodes.Add(teachers);

            tree.ExpandAll();
        }

        public static void PopulateDataGrid(DataGridView grid)
        {
            grid.Rows.Clear();

            foreach(User user in DataBank.Instance.GetUsers())
            {
                grid.Rows.Add(user.Name, user.LastName, user.DateOfBirth, user.Address);
            }
        }
        public static void PopulateDataGrid(DataGridView grid, List<User> users)
        {
            grid.Rows.Clear();

            foreach(User user in users)
            {
                grid.Rows.Add(user.Name, user.LastName, user.DateOfBirth, user.Address);
            }
        }
    }
}
