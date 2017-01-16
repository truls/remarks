module PPmrk (toMrk) where

import Ast

import Text.PrettyPrint

toMrk :: [Judgement] -> String
toMrk js = render $ vcat $ map (formatJudgement 1) js

formatJudgement level (Judgement (header, comments, judgements)) =
  formatHeader level header $+$
  (nest 2 $ vcat $ map (formatComment) comments) $+$
  (vcat $ map (formatJudgement (level + 1)) judgements)

isIntegral :: Double -> Bool
isIntegral x = x == fromInteger (round x)

pointsDoc :: Double -> Doc
pointsDoc v | isIntegral v = integer (round v)
pointsDoc v = double v

formatHeader level (Header (title, point, maxPoints)) =
  (text $ replicate level '#') <+> text title <> colon <+>
    pointsDoc point <> text "/" <> pointsDoc maxPoints

formatComment (Comment (mood, commentParts)) =
  formatMood mood <+> (vcat $ map formatCommentPart commentParts)

formatMood Positive  = text "+"
formatMood Negative  = text "-"
formatMood Neutral   = text "*"
formatMood Impartial = text "?"

formatCommentPart (CommentStr string)  = text string
formatCommentPart (CommentCmt comment) = nest 2 $ formatComment comment