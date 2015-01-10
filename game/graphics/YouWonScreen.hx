package game.graphics;
/*
	Спрайт с текстом "Вы выиграли"
	Нажатие по нему вызывает функцию restart
*/

// подключим зависимости
import flash.display.*;
import flash.events.*;
import flash.text.*;
import game.data.*;
import game.graphics3d.*;

class YouWonScreen extends Sprite implements game.graphics3d.IRenderable {

	private var restart:Void -> Void;
	private var textField:TextField;
	private var finalScore:FinalScore;
	private var texture:ImageTexture;

	public function new(score:Int, level:Int, restart:Void -> Void) {
		super();
		// заполним экран цветом для привлечения внимания
		graphics.beginFill(0x22FF22, 0.3);
		graphics.drawRect(0,0,Gameplay.SCREEN_WIDTH,Gameplay.SCREEN_HEIGHT);
		graphics.endFill();

		// настроим шрифт
		var format:TextFormat = new TextFormat();
		format.size = 35;
		format.align = TextFormatAlign.CENTER;
		format.font = "Arial";

		// создадим текстовое поле
		textField = new TextField();
		textField.textColor = 0xFFFFFF;
		textField.border = false;
		textField.wordWrap = false;
		textField.width = Gameplay.SCREEN_WIDTH;
		textField.height = 222;
		textField.selectable = false;
		textField.x = 0;
		textField.y = Gameplay.SCREEN_HEIGHT / 2;
		textField.defaultTextFormat = format;
		textField.embedFonts = false; // используем системный шрифт
			// таким образом его не придется встраивать в SWF файл
		textField.antiAliasType = AntiAliasType.ADVANCED;

		// установим текст
		textField.text = Texts.YouWon;
		addChild(textField);

		// добавим текстовое поле об успехах игрока
		addChild(finalScore = new FinalScore(score, level));

		this.restart = restart;

		// создадим текстуру
		texture = new ImageTexture(TextToBitmap.draw(textField));

		// слушаем событие клика мышкой
		addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(event:Event) {
		// уберем текущий спрайт,
		parent.removeChild(this);
		// и вызовем функцию рестарта игры
		this.restart();
	}

	public function render3d(context:game.graphics3d.Context):Void {
		// отрисуем фон
		context.drawRectangle(0x22FF22, 0.3);
		// отрисуем изображение текста с заданной ранее текстурой
		context.drawBitmap(x + textField.x, y + textField.y,
		                   textField.width, textField.height,
		                   texture);
		// отправим событие отрисовки в объект отображающий количество очков
		finalScore.render3d(context);
	}
}