const { response } = require('express');
const Usuario = require('../models/usuario');

const getUsuarios = async ( req, res = response ) => {

    const desde = Number( req.query.desde ) || 0; // paginacion 

    const usuarios = await Usuario
        .find({ _id: { $ne: req.uid } }) // condicion negacion   $ne:
        .sort('-online') // orden 
        .skip(desde) // paginacion
        .limit(20) // paginacion 

    
    res.json({
        ok: true,
        usuarios,
    })
}



module.exports = {
    getUsuarios
}