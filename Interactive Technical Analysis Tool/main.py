import yfinance as yf
import talib as ta
import plotly.graph_objs as go
import plotly.io as pio
from plotly.subplots import make_subplots

pio.renderers.default = 'browser'

#ticker = 'AAPL' #Apple
#ticker = 'ALVO' #Alvotech
ticker = 'AA' #Alcoa
start_date = '2021-01-01'
end_date = '2024-12-31'

df = yf.download(ticker, start_date, end_date)

#CALC
df['SMA'] = ta.SMA(df['Close'], timeperiod=20) #Simple Moving Average (20d)
df['EMA15'] = ta.EMA(df['Close'], timeperiod=15) #Exponential Moving Average (15d)
df['RSI'] = ta.RSI(df['Close'], timeperiod=14) #Relative Strength Index (14d)
df['Upper_BB'], df['Middle_BB'], df['Lower_BB'] = ta.BBANDS(df['Close'], timeperiod=20, nbdevup=2, nbdevdn=2, matype=0) # Bollinger Bands (upper, lower, middle)

fig = make_subplots(rows=2,
                    cols=1,
                    shared_xaxes=True,
                    vertical_spacing=0.2,
                    row_heights=[0.7, 0.3],
                    subplot_titles=[f'{ticker} Price and Indicators', 'RSI']
                    )
candlestick = go.Candlestick(
    x=df.index,
    open=df.Open,
    high=df.High,
    low=df.Low,
    close=df.Close,
    name='Price'
)

sma_line = go.Scatter(
    x=df.index,
    y=df.SMA,
    line={'color': 'blue', 'width': 2},
    name='SMA'
)

ema15_line = go.Scatter(
    x=df.index,
    y=df.EMA15,
    line={'color': 'cyan', 'width': 2},
    name='EMA15'
)

upper_bb = go.Scatter(
    x=df.index,
    y=df['Upper_BB'],
    line={'color': 'red', 'width': 1},
    name='Upper_BB'
)

lower_bb = go.Scatter(
    x=df.index,
    y=df['Lower_BB'],
    line={'color': 'red', 'width': 1},
    name='Lower_BB'
)

middle_bb = go.Scatter(
    x=df.index,
    y=df['Middle_BB'],
    line={'color': 'green', 'width': 1},
    name='Middle_BB'
)

fig.add_trace(candlestick, row=1, col=1)
fig.add_trace(sma_line, row=1, col=1)
fig.add_trace(ema15_line, row=1, col=1)
fig.add_trace(upper_bb, row=1, col=1)
fig.add_trace(lower_bb, row=1, col=1)
fig.add_trace(middle_bb, row=1, col=1)

rsi = go.Scatter(
    x=df.index,
    y=df.RSI,
    line={'color':'purple', 'width':2},
    name='RSI'
)

fig.add_trace(rsi, row=2, col=1)

mark30 = go.layout.Shape(
    type='line',
    x0=df.index[0],
    y0=30,
    x1=df.index[-1],
    y1=30,
    line={'color': 'gray', 'width': 1, 'dash': 'dash'}
)

mark70 = go.layout.Shape(
    type='line',
    x0=df.index[0],
    y0=70,
    x1=df.index[-1],
    y1=70,
    line={'color': 'gray', 'width': 1, 'dash': 'dash'}
)

fig.add_shape(mark30, row=2, col=1)
fig.add_shape(mark70, row=2, col=1)

fig.update_layout(
    title=f'{ticker} Technical Analysis',
    yaxis_title='Price',
    xaxis_title='Date',
    xaxis_rangeslider_visible=False,
    height=800,
    template='plotly_dark'
)

fig.update_yaxes(range=[0,100], row=2, col=1)

fig.show()

