class Receita:
    def __init__(self, _nome: str, _tipo: str,
                 _modo_preparo: str, _rendimento: int,
                 _ingredientes: dict):
        self.nome = _nome
        self.tipo = _tipo
        self.modo_preparo = _modo_preparo
        self.rendimento = _rendimento
        self.ingredientes = _ingredientes

    @property
    def nome(self) -> str:
        return self.__nome
    
    @nome.setter
    def nome(self, _nome: str) -> None:
        self.__nome = _nome
    
    @property
    def tipo(self) -> str:
        return self.__tipo
    
    @tipo.setter
    def tipo(self, _tipo: str) -> None:
        self.__tipo = _tipo

    @property
    def modo_preparo(self) -> str:
        return self.__modo_preparo
    
    @modo_preparo.setter
    def modo_preparo(self, _modo_preparo: str) -> None:
        self.__modo_preparo = _modo_preparo

    @property
    def rendimento(self) -> int:
        return self.__rendimento
    
    @rendimento.setter
    def rendimento(self, _rendimento: int) -> None:
        self.__rendimento = _rendimento

    @property
    def ingredientes(self) -> dict:
        return self.__ingredientes
    
    @ingredientes.setter
    def ingredientes(self, _ingredientes: dict) -> None:
        self.__ingredientes = _ingredientes
    
    #def tem_ingredientes(self) -> None:
    #    pass

    def imprime_receita(self) -> None:
        print(f"==={self.__nome}===")
        for key, value in self.__ingredientes.items():
            print(f"\033[31m{key}: {value}\033[0m")


if __name__ == "main":
    receita1 = Receita("Brigadeiro de panela",
                   "Sobremesa",
                   "adicione td numa panela",
                   1, "achocolatado,etc")
    receita1.imprime_receita()
