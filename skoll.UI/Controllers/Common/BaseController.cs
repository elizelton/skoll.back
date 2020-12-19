using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using skoll.Aplicacao.Common.Interfaces;

namespace skoll.UI.Controllers.Common
{
    public class BaseController : Controller
    {
        protected IUnitOfWork uow;
    }
}
