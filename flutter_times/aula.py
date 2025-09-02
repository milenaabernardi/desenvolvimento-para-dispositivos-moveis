class receitas:
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
        pass