using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Session;
using Microsoft.EntityFrameworkCore;
using Auth.Models;
using System.Diagnostics;
using Newtonsoft.Json.Linq;

namespace Auth.Controllers
{
    [Route("user/")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly COMP2001_KNouchinContext _context;

        public UsersController(COMP2001_KNouchinContext context)
        {
            _context = context;
        }

        // GET: user/
        [HttpGet]
        public async Task<ActionResult<String>> GetUser(User user)
        {
            // Check if the email and password in the request match the ones in the DB.
            bool valid = DataAccess.Validate(user);
            this.Response.StatusCode = 200;
            this.Response.ContentType = "application/json";

            // Create a new object that'll later contain data that'll be returned to the client in JSON format.
            dynamic response = new { };

            if(valid)
			{
                // If the email and password provided match the ones in the DB, generate an API access token.
                string authToken = Convert.ToBase64String(Guid.NewGuid().ToByteArray());

                // Store the access token in the "Session" object.
                HttpContext.Session.SetString(authToken, "verified");

                // Return the API key as a header.
                this.Response.Headers.Add("api_key", authToken);

                // Set the client's verification status.
                response = new { verified = valid.ToString().ToLower() };
            }
            else
			{
                response = new { verified = "false" };
			}

            // Turn the "response" object into a JSON string, and return it to the client.
			return JObject.FromObject(response).ToString(Newtonsoft.Json.Formatting.None);
        }

        // PUT: user/{id}
        [HttpPut("{id}")]
        public async void PutUser(User user, int id)
        {
            // Get the value of the "api_key" header from the request.
            string authHeader = this.Request.Headers["api_key"];

            // If the header doesn't have a value, then the client isn't authorized to use the API.
            if(authHeader != null)
            {
                try
                {
                    // Use the value of the "api_key" header as a key to check whether or not it's verified.
                    string authToken = HttpContext.Session.GetString(authHeader);
                    if(authToken == "verified")
                    {
                        // Update the user's details.
                        DataAccess.Update(user, id);
                        this.Response.StatusCode = 204;
                    }
                    else
                    {
                        // Set the response status code to 401, which tells the client that they aren't authorized to use the API.
                        this.Response.StatusCode = 401;
                    }
                }
                catch(Exception e)
                {
                    Debug.WriteLine(e.Message);
                }
            }
            else
            {
                this.Response.StatusCode = 401;
            }
        }

        // POST: user/
        [HttpPost]
        public async Task<ActionResult<String>> PostUser(User user)
        {
            // Create a new object that'll later contain data that'll be returned to the client in JSON format.
            dynamic response = new { };

            // Get the value of the "api_key" header from the request.
            string authHeader = this.Request.Headers["api_key"];

            // If the header doesn't have a value, then the client isn't authorized to use the API.
            if(authHeader != null)
            {
                try
                {
                    // Use the value of the "api_key" header as a key to check whether or not it's verified.
                    string authToken = HttpContext.Session.GetString(authHeader);
                    if(authToken == "verified")
                    {
                        // Create the user account.
                        String result = DataAccess.Register(user, "Response");

                        this.Response.ContentType = "application/json";

                        // Convert the response from the Stored Procedure into an object.
                        dynamic parsed = JObject.Parse(result);
                        if(parsed["code"] == "200")
                        {
                            // If the user was created, set the HTTP status code to 200, and return the UserID to the client.
                            this.Response.StatusCode = 200;
                            response = new { UserID = parsed["UserID"] };
                        }
                        else if(parsed["code"] == "208")
                        {
                            // If a user with the specified email already exists, set the status code to 208, and return a message telling the client what happened.
                            this.Response.StatusCode = 208;
                            response = new { message = "Call successful, but email already exists and so new entry not made" };
                        }
                        else
                        {
                            this.Response.StatusCode = 404;
                            response = new { message = "Bad request" };
                        }
                    }
                    else
                    {
                        this.Response.StatusCode = 401;
                        response = new { message = "Access not authorized. Use an \"api_key\" header with a valid access token." };
                    }
                }
                catch(Exception e)
                {
                    response = new { message = "Error: " + e.Message };
                }
            }
            else
            {
                this.Response.StatusCode = 401;
                response = new { message = "Access not authorized. Use an \"api_key\" header with a valid access token." };
            }

            // Turn the "response" object into a JSON string, and return it to the client as a response.
            return JObject.FromObject(response).ToString(Newtonsoft.Json.Formatting.None);
        }

        // DELETE: user/{id}
        [HttpDelete("{id}")]
        public async void DeleteUser(int id)
        {
            // Get the value of the "api_key" header from the request.
            string authHeader = this.Request.Headers["api_key"];

            // If the header doesn't have a value, then the client isn't authorized to use the API.
            if(authHeader != null)
			{
                try
				{
                    // Use the value of the "api_key" header as a key to check whether or not it's verified.
                    string authToken = HttpContext.Session.GetString(authHeader);
                    if(authToken == "verified")
					{
                        // Delete the user.
                        DataAccess.Delete(id);
                        this.Response.StatusCode = 204;
					}
                    else
					{
                        this.Response.StatusCode = 401;
					}
                }
                catch(Exception e)
				{
                    Debug.WriteLine(e.Message);
				}
            }
            else
			{
                this.Response.StatusCode = 401;
            }
        }
    }
}
