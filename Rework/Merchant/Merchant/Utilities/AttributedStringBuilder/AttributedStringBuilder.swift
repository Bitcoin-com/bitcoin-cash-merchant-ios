//
//  AttributedStringBuilder.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/22/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

protocol BuilderCompatible: class {
	var attributedText: NSAttributedString? { get set }
	var text: String? { get }
	var bd: AttributedStringBuilder { get }
}

extension BuilderCompatible {
	public var bd: AttributedStringBuilder { return AttributedStringBuilder(self) }
}

class AttributedStringBuilder {
	
	// MARK: - Properties
	private let compatible: BuilderCompatible?
	
	// MARK: - Initializers
	public init() {
		self.compatible = nil
	}
	
	public init(_ compatible: BuilderCompatible?) {
		self.compatible = compatible
	}
	
	// MARK: - Public API
	@discardableResult
	open func apply(on text: String, _ closure: (Builder) -> Void) -> NSAttributedString {
		let builder = Builder(text: text)
		closure(builder)
		
		let attributedString = builder.create()
		compatible?.attributedText = attributedString
		
		return attributedString
	}
	
	@discardableResult
	open func apply(_ closure: (Builder) -> Void) -> NSAttributedString {
		let builder = Builder(text: compatible?.text ?? "")
		closure(builder)
		
		let attributedString = builder.create()
		compatible?.attributedText = attributedString
		
		return attributedString
	}
	
}

class Builder {
	
	private enum StringBuilderError: Error {
		case invalidRange
		case substringNotFound
		
		var localizedTitle: String? {
			return "Error"
		}
	}
	
	// MARK: - Properties
	let text: String
	private var attributes = [NSAttributedString.Key: Any]()
	private var rangeAttributes = [(NSAttributedString.Key, Any, NSRange)]()
	
	// MARK: - Initializer
	public init(text: String) {
		self.text = text
	}
	
}

extension Builder {
	
	// MARK: - Custom Initializers
	open func create() -> NSAttributedString {
		if rangeAttributes.isEmpty {
			return NSAttributedString(string: text, attributes: attributes)
		}
		
		return createMutable() as NSAttributedString
	}
	
	open func createMutable() -> NSMutableAttributedString {
		let mutableString = NSMutableAttributedString(string: text, attributes: attributes)
		for (key, value, range) in rangeAttributes {
			mutableString.addAttribute(key, value: value, range: range)
		}
		
		return mutableString
	}
	
}

extension Builder {
	
	// MARK: - Add Attribute Setters
	@discardableResult
	open func addAttribute(key: NSAttributedString.Key, object: Any?) -> Builder {
		if let object = object {
			attributes[key] = object
		}
		return self
	}
	
	@discardableResult
	open func addAttribute(key: NSAttributedString.Key, object: Any?, range: NSRange) -> Builder {
		guard validate(range: range) else { return self }
		if let object = object {
			rangeAttributes.append((key, object, range))
		}
		return self
	}
	
	@discardableResult
	open func addAttribute(key: NSAttributedString.Key, object: Any?, substring: String) -> Builder {
		guard let range = text.range(of: substring) else { return self }
		return addAttribute(key: key, object: object, range: NSRange(range, in: text))
	}
	
}

extension Builder {
	
	// MARK: - Other Setters
	@discardableResult
	open func setFont(_ font: UIFont?) -> Builder {
		return addAttribute(key: .font, object: font)
	}
	
	@discardableResult
	open func setTextColor(_ color: UIColor?) -> Builder {
		return addAttribute(key: .foregroundColor, object: color)
	}
	
	@discardableResult
	open func setUnderlineStyle(_ style: NSUnderlineStyle) -> Builder {
		return addAttribute(key: .underlineStyle, object: style.rawValue)
	}
	
	@discardableResult
	open func setParagraphStyle(lineSpacing: CGFloat,
								heightMultiple: CGFloat = 1,
								lineHeight: CGFloat,
								lineBreakMode: NSLineBreakMode = .byWordWrapping,
								textAlignment: NSTextAlignment = .left) -> Builder {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing
		paragraphStyle.lineHeightMultiple = heightMultiple
		paragraphStyle.minimumLineHeight = lineHeight
		paragraphStyle.lineBreakMode = lineBreakMode
		paragraphStyle.alignment = textAlignment
		return addAttribute(key: .paragraphStyle, object: paragraphStyle)
	}
	
	@discardableResult
	open func setFont(_ font: UIFont?, range: NSRange) -> Builder {
		return addAttribute(key: .font, object: font, range: range)
	}
	
	@discardableResult
	open func setTextColor(_ color: UIColor?, range: NSRange) -> Builder {
		return addAttribute(key: .foregroundColor, object: color, range: range)
	}
	
	@discardableResult
	open func setUnderlineStyle(_ style: NSUnderlineStyle, range: NSRange) -> Builder {
		return addAttribute(key: .underlineStyle, object: style.rawValue, range: range)
	}
	
	@discardableResult
	open func setParagraphStyle(lineSpacing: CGFloat,
								heightMultiple: CGFloat = 1,
								lineHeight: CGFloat,
								lineBreakMode: NSLineBreakMode = .byWordWrapping,
								textAlignment: NSTextAlignment = .left,
								range: NSRange) -> Builder {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing
		paragraphStyle.lineHeightMultiple = heightMultiple
		paragraphStyle.minimumLineHeight = lineHeight
		paragraphStyle.lineBreakMode = lineBreakMode
		paragraphStyle.alignment = textAlignment
		return addAttribute(key: .paragraphStyle, object: paragraphStyle, range: range)
	}
	
	@discardableResult
	open func setFont(_ font: UIFont?, substring: String) -> Builder {
		return addAttribute(key: .font, object: font, substring: substring)
	}
	
	@discardableResult
	open func setTextColor(_ color: UIColor?, substring: String) -> Builder {
		return addAttribute(key: .foregroundColor, object: color, substring: substring)
	}
	
	@discardableResult
	open func setUnderlineStyle(_ style: NSUnderlineStyle, substring: String) -> Builder {
		return addAttribute(key: .underlineStyle, object: style.rawValue, substring: substring)
	}
	
	@discardableResult
	open func setParagraphStyle(lineSpacing: CGFloat,
								heightMultiple: CGFloat = 1,
								lineHeight: CGFloat,
								lineBreakMode: NSLineBreakMode = .byWordWrapping,
								textAlignment: NSTextAlignment = .left,
								substring: String) -> Builder {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing
		paragraphStyle.lineHeightMultiple = heightMultiple
		paragraphStyle.minimumLineHeight = lineHeight
		paragraphStyle.lineBreakMode = lineBreakMode
		paragraphStyle.alignment = textAlignment
		return addAttribute(key: .paragraphStyle, object: paragraphStyle, substring: substring)
	}
	
}

private extension Builder {
	
	// MARK: - Private API
	func validate(range: NSRange) -> Bool {
		if text.count < range.location + range.length || range.location < 0 {
			return false
		}
		
		return true
	}
	
}
