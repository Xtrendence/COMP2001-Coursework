using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
            bool valid = DataAccess.Validate(user);
            this.Response.StatusCode = 200;
            this.Response.ContentType = "application/json";
            dynamic response = new { verified = valid.ToString().ToLower() };
			return JObject.FromObject(response).ToString(Newtonsoft.Json.Formatting.None);
        }

        // PUT: user/{id}
        [HttpPut("{id}")]
        public async void PutUser(User user, int id)
        {
            DataAccess.Update(user, id);
            this.Response.StatusCode = 204;
        }

        // POST: user/
        [HttpPost]
        public async Task<ActionResult<String>> PostUser(User user)
        {
            String result = DataAccess.Register(user, "Response");
            this.Response.ContentType = "application/json";
            dynamic response;
            dynamic parsed = JObject.Parse(result);
            if(parsed["code"] == "200") 
            {
                this.Response.StatusCode = 200;
                response = new { UserID = parsed["UserID"] };
			}
            else if(parsed["code"] == "208")
			{
                this.Response.StatusCode = 208;
                response = new { message = "Call successful, but email already exists and so new entry not made" };
            }
            else
			{
                this.Response.StatusCode = 404;
                response = new { message = "Bad request" };
			}
            return JObject.FromObject(response).ToString(Newtonsoft.Json.Formatting.None);
        }

        // DELETE: user/{id}
        [HttpDelete("{id}")]
        public async void DeleteUser(int id)
        {
            DataAccess.Delete(id);
            this.Response.StatusCode = 204;
        }
    }
}
