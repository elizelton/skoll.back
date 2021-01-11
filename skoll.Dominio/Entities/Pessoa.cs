using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class Pessoa : BaseEntity
    {
        public string cpfCnpj { get; set; }
        public string numero { get; set; }
        public string complemento { get; set; }
        public string bairro { get; set; }
        public string nome { get; set; }
        public string email { get; set; }
        public string cep { get; set; }
        public string logradouro { get; set; }
        public Cidade Cidade { get; set; }
        public List<Telefone> telefones { get; set; }
        public Pessoa ToPessoa()
        {
            Pessoa pessoa = new Pessoa();
            pessoa.Id = this.Id;
            pessoa.cpfCnpj = this.cpfCnpj;
            pessoa.numero = this.numero;
            pessoa.complemento = this.complemento;
            pessoa.bairro = this.bairro;
            pessoa.nome = this.nome;
            pessoa.email = this.email;
            pessoa.cep = this.cep;
            pessoa.logradouro = this.logradouro;
            pessoa.Cidade = this.Cidade;
            pessoa.telefones = this.telefones;

            return pessoa;
        }

        public void prenchePessoa(Pessoa pessoa)
        {
            this.Id = pessoa.Id;
            this.cpfCnpj = pessoa.cpfCnpj;
            this.numero = pessoa.numero;
            this.complemento = pessoa.complemento;
            this.bairro = pessoa.bairro;
            this.nome = pessoa.nome;
            this.email = pessoa.email;
            this.cep = pessoa.cep;
            this.logradouro = pessoa.logradouro;
            this.Cidade = pessoa.Cidade;
            this.telefones = pessoa.telefones;
        }
    }
}
