var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var sellerClientRouter = require('./routes/sellerClient');
var sellerRouter = require('./routes/seller');
var salePreviewRouter = require('./routes/salePreview')
var loginRouter =  require('./routes/login')
var orderPreviewRouter =  require('./routes/orderPreview')
var orderDetailsRouter = require('./routes/orderDetails')
var buyerRouter = require('./routes/buyer')
var registerBuyerRouter = require('./routes/registerBuyer')

var productRouter= require('./routes/product')

var saleDetailsRouter = require('./routes/saleDetails');
const { PreconditionFailed } = require('http-errors');

var deliveryPreviewRouter = require('./routes/deliveryPreview')

var saleDetailsRouter = require('./routes/saleDetails')
var confirmSaleRouter = require('./routes/confirmSale')
var createOrder=require('./routes/OrderCreate')
var createPedido= require('./routes/createPedido')
// var usersRouter = require('./routes/users');
var catalogueRouter = require('./routes/catalogue')

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/sellerclient',sellerClientRouter);
app.use('/seller',sellerRouter);
app.use('/salepreview',salePreviewRouter)
app.use('/product', productRouter)
app.use('/orderpreview',orderPreviewRouter)
app.use('/orderdetails',orderDetailsRouter)
app.use('/buyer',buyerRouter)
app.use('/register',registerBuyerRouter)

app.use('/saledetails',saleDetailsRouter)
app.use('/createorder', createOrder)
//app.use('/pedido', pedidoRouter)

app.use('/deliverypreview', deliveryPreviewRouter)

app.use('/confirmsale',confirmSaleRouter)
app.use('/users',loginRouter)
app.use('/createpedido', createPedido)
// app.use('/users', usersRouter);
app.use('/catalogue', catalogueRouter)

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
