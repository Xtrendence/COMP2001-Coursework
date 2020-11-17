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
		public static String Register(User user, String output)
		{
			String response = "";
			using(SqlConnection conn = new SqlConnection(connection))
			{
				conn.Open();

				SqlCommand cmd = new SqlCommand("Register", conn);

				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@FirstName", user.FirstName));
				cmd.Parameters.Add(new SqlParameter("@LastName", user.LastName));
				cmd.Parameters.Add(new SqlParameter("@Email", user.Email));
				cmd.Parameters.Add(new SqlParameter("@Password", user.UserPassword));
				cmd.Parameters.Add(new SqlParameter("@ResponseMessage", output));

				using(SqlDataReader reader = cmd.ExecuteReader())
				{
					while(reader.Read())
					{
						response += reader.GetString(0);
					}
				}
			}
			return response;
		}
		public static void Update(User user, int id)
		{
			using(SqlConnection conn = new SqlConnection(connection))
			{
				conn.Open();

				SqlCommand cmd = new SqlCommand("UpdateUser", conn);

				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@UserID", id));
				cmd.Parameters.Add(new SqlParameter("@FirstName", user.FirstName));
				cmd.Parameters.Add(new SqlParameter("@LastName", user.LastName));
				cmd.Parameters.Add(new SqlParameter("@Email", user.Email));
				cmd.Parameters.Add(new SqlParameter("@Password", user.UserPassword));

				cmd.ExecuteNonQuery();
			}
		}
		public static void Delete(int id)
		{
			using(SqlConnection conn = new SqlConnection(connection))
			{
				conn.Open();

				SqlCommand cmd = new SqlCommand("DeleteUser", conn);

				cmd.CommandType = CommandType.StoredProcedure;

				cmd.Parameters.Add(new SqlParameter("@UserID", id));

				cmd.ExecuteNonQuery();
			}
		}
	}
}
