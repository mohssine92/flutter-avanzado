const { Schema, model } = require('mongoose');

const MensajeSchema = Schema({

    de: {
        type: Schema.Types.ObjectId, // para hacer ref a id user de db 
        ref: 'Usuario', // a que modelo 
        required: true
    },
    para: {
        type: Schema.Types.ObjectId,
        ref: 'Usuario',
        required: true
    },
    mensaje: {
        type: String,
        required: true
    }

}, { // es config adicional al schema  - Feha de la base de datos 
    timestamps: true
});

MensajeSchema.method('toJSON', function() {
    const { __v, _id, ...object } = this.toObject();
    return object;
})



module.exports = model('Mensaje', MensajeSchema );
// Model : Mensaje -> en db collecion Mensajes 