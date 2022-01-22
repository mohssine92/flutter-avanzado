
const Mensaje = require('../models/mensaje');

const obtenerChat = async(req, res) => {

     // steado en proceso Token 
    const miId = req.uid;

    // quien la persona quiero leer mensajes como set yo JWT 
    const mensajesDe = req.params.de;
  

    const last30 = await Mensaje.find({
        // condicion or [{condicion1},{condicion2}] 118
        $or: [{ de: miId, para: mensajesDe }, { de: mensajesDe, para: miId } ]
    })
    .sort({ createdAt: 'desc' }) // orden
    .limit(30);  

    res.json({
        ok: true,
        mensajes: last30
    })

}



module.exports = {
    obtenerChat
}