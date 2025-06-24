// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    // Variables de estado
    address public propietario;
    uint256 public tiempoFinalizacion;
    uint256 public mejorOferta;
    address public mejorOferente;
    bool public subastaFinalizada;
    
    // Mapeo para almacenar depósitos de cada participante
    mapping(address => uint256) public depositos;
    
    // Array para almacenar todas las ofertas
    struct Oferta {
        address oferente;
        uint256 monto;
        uint256 timestamp;
    }
    Oferta[] public ofertas;
    
    // Eventos
    event NuevaOferta(address indexed oferente, uint256 monto, uint256 timestamp);
    event SubastaFinalizada(address ganador, uint256 montoGanador);
    event DepositoRetirado(address indexed oferente, uint256 monto);
    
    // Modificadores
    modifier soloMientrasActiva() {
        require(!subastaFinalizada, "La subasta ya ha finalizado");
        require(block.timestamp < tiempoFinalizacion, "Tiempo de subasta expirado");
        _;
    }
    
    modifier soloPropietario() {
        require(msg.sender == propietario, "Solo el propietario puede ejecutar esta funcion");
        _;
    }
    
    // Constructor
    constructor(uint256 _duracionMinutos) {
        propietario = msg.sender;
        tiempoFinalizacion = block.timestamp + (_duracionMinutos * 1 minutes);
        subastaFinalizada = false;
        mejorOferta = 0;
    }
    
    // Función para ofertar
    function ofertar() public payable soloMientrasActiva {
        require(msg.value > 0, "La oferta debe ser mayor a 0");
        
        uint256 nuevaOferta = depositos[msg.sender] + msg.value;
        uint256 minimaOfertaRequerida = mejorOferta + (mejorOferta * 5 / 100); // 5% más
        
        require(nuevaOferta > minimaOfertaRequerida, "La oferta debe ser al menos 5% mayor que la actual");
        
        // Actualizar depósito del oferente
        depositos[msg.sender] = nuevaOferta;
        
        // Actualizar mejor oferta
        mejorOferta = nuevaOferta;
        mejorOferente = msg.sender;
        
        // Guardar la oferta en el array
        ofertas.push(Oferta({
            oferente: msg.sender,
            monto: nuevaOferta,
            timestamp: block.timestamp
        }));
        
        // Extender tiempo si quedan menos de 10 minutos
        if (tiempoFinalizacion - block.timestamp < 10 minutes) {
            tiempoFinalizacion = block.timestamp + 10 minutes;
        }
        
        emit NuevaOferta(msg.sender, nuevaOferta, block.timestamp);
    }
    
    // Función para mostrar ganador
    function mostrarGanador() public view returns (address ganador, uint256 ofertaGanadora) {
        return (mejorOferente, mejorOferta);
    }
    
    // Función para mostrar todas las ofertas
    function mostrarOfertas() public view returns (Oferta[] memory) {
        return ofertas;
    }
    
    // Función para obtener número de ofertas
    function numeroOfertas() public view returns (uint256) {
        return ofertas.length;
    }
    
    // Función para retirar excedente (funcionalidad avanzada)
    function retirarExcedente() public {
        require(depositos[msg.sender] > 0, "No tienes depositos");
        
        uint256 montoRetirar = 0;
        
        if (msg.sender == mejorOferente) {
            // Si es el mejor oferente, puede retirar todo excepto su mejor oferta
            montoRetirar = depositos[msg.sender] - mejorOferta;
        } else {
            // Si no es el mejor oferente, puede retirar todo su depósito
            montoRetirar = depositos[msg.sender];
        }
        
        require(montoRetirar > 0, "No hay monto disponible para retirar");
        
        depositos[msg.sender] -= montoRetirar;
        
        (bool success, ) = payable(msg.sender).call{value: montoRetirar}("");
        require(success, "Fallo en la transferencia");
        
        emit DepositoRetirado(msg.sender, montoRetirar);
    }
    
    // Función para finalizar subasta
    function finalizarSubasta() public {
        require(block.timestamp >= tiempoFinalizacion || msg.sender == propietario, 
                "Subasta aun activa o no eres el propietario");
        require(!subastaFinalizada, "Subasta ya finalizada");
        
        subastaFinalizada = true;
        
        emit SubastaFinalizada(mejorOferente, mejorOferta);
    }
    
    // Función para devolver depósitos
    function devolverDepositos() public {
        require(subastaFinalizada, "La subasta debe estar finalizada");
        require(depositos[msg.sender] > 0, "No tienes depositos para retirar");
        require(msg.sender != mejorOferente, "El ganador no puede retirar su deposito");
        
        uint256 montoDevolver = depositos[msg.sender];
        uint256 comision = montoDevolver * 2 / 100; // 2% de comisión
        uint256 montoFinal = montoDevolver - comision;
        
        depositos[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: montoFinal}("");
        require(success, "Fallo en la transferencia");
        
        // Enviar comisión al propietario
        (bool successComision, ) = payable(propietario).call{value: comision}("");
        require(successComision, "Fallo en transferencia de comision");
    }
    
    // Función para que el propietario retire las ganancias
    function retirarGanancias() public soloPropietario {
        require(subastaFinalizada, "La subasta debe estar finalizada");
        require(mejorOferta > 0, "No hay ofertas ganadoras");
        
        uint256 ganancias = mejorOferta;
        mejorOferta = 0; // Evitar doble retiro
        
        (bool success, ) = payable(propietario).call{value: ganancias}("");
        require(success, "Fallo en la transferencia");
    }
    
    // Función para consultar tiempo restante
    function tiempoRestante() public view returns (uint256) {
        if (block.timestamp >= tiempoFinalizacion) {
            return 0;
        }
        return tiempoFinalizacion - block.timestamp;
    }
    
    // Función para consultar estado de la subasta
    function estadoSubasta() public view returns (
        address _propietario,
        uint256 _tiempoFinalizacion,
        uint256 _mejorOferta,
        address _mejorOferente,
        bool _subastaFinalizada,
        uint256 _tiempoRestante
    ) {
        return (
            propietario,
            tiempoFinalizacion,
            mejorOferta,
            mejorOferente,
            subastaFinalizada,
            tiempoRestante()
        );
    }
}