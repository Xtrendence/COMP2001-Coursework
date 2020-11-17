using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace Auth.Models
{
	public static class DataAccess
	{
		static private String connection = "Data Source=socem1.uopnet.plymouth.ac.uk;Initial Catalog=COMP2001_KNouchin;Persist Security Info=True;User ID=KNouchin;Password=***REMOVED***";

		public static bool Validate(User user)
		{
			bool valid = false;
			using(SqlConnection conn = new SqlConnection(connection))
			{
				conn.Open();

				SqlCommand cmd = new SqlCommand("ValidateUser", conn);

				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@Email", user.Email));
				cmd.Parameters.Add(new SqlParameter("@Password", user.UserPassword));

				int result = cmd.ExecuteNonQuery();
				if(result == 1)
				{
					valid = true;
				}
			}
			return valid;
		}
		static void Register(User user, String output)
		{

		}
		static void Update(User user, int id)
		{

		}
		static void Delete(int id)
		{

		}
	}
}
