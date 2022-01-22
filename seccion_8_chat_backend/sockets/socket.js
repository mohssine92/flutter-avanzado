const { io } = require('../index');
const { comprobarJWT } = require('../helpers/jwt');
const { usuarioConectado, usuarioDesconectado, grabarMensaje } = require('../controllers/socket');

// Mensajes de Sockets
io.on('connection', client => {
   
   
    const [ valido, uid ] = comprobarJWT( client.handshake.headers['x-token'] )
    // Verificar autenticación
    if ( !valido ) { return client.disconnect(); }

    // Cliente autenticado db
    usuarioConectado( uid );
    

    // cada client socket conected sera unido a uana sala  en el nombre de su uid de mongodb 
    client.join(uid)

    console.log(uid);

    // privateCliente -> server -> clientPrivate 
    client.on('mensaje-personal', async( payload ) => {
       await grabarMensaje(payload)
       io.to(payload.para).emit('mensaje-personal', payload)
      // client.broadcast.to('zcxdxzcvftfyhngjuy89098').emit('mensaje-personal', payload) 
    })



    client.on('disconnect', () => {
       usuarioDesconectado(uid); // db
    });


    
    // client.on('mensaje', ( payload ) => {
    //     console.log('Mensaje', payload);
    //     io.emit( 'mensaje', { admin: 'Nuevo mensaje' } );
    // });


});
