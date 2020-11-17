﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Auth.Models;
using System.Diagnostics;

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
            return "{ Status:200, Validated:" + valid.ToString().ToLower() + " }";
        }

        // PUT: user/{id}
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async void PutUser(User user, int id)
        {
            DataAccess.Update(user, id);
        }

        // POST: user/
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<String>> PostUser(User user)
        {
            String response = DataAccess.Register(user, "Response");
            return response;
        }

        // DELETE: user/{id}
        [HttpDelete("{id}")]
        public async void DeleteUser(int id)
        {
            DataAccess.Delete(id);
        }

        private bool UserExists(int id)
        {
            return _context.Users.Any(e => e.UserId == id);
        }
    }
}
