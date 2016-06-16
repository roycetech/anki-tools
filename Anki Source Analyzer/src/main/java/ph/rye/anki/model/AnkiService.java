/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.anki.model;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import ph.rye.anki.util.CardIter;
import ph.rye.common.lang.Ano;
import ph.rye.common.lang.StringUtil;


/**
 * @author royce
 *
 */
public class AnkiService {


    private final static Logger LOGGER =
            Logger.getLogger(AnkiService.class.getName());


    static final String TAGS_MARKER = "@Tags: ";


    private transient boolean fileLoaded;
    private transient boolean refreshing;


    private final transient TagModel tagModel = new TagModel();
    private final transient CardModel cardModel = new CardModel();
    private final transient TagModel cardTagModel = new TagModel() {


        /** */
        private static final long serialVersionUID = 1L;


        /** {@inheritDoc} */
        @Override
        public void setValueAt(final Object aValue, final int rowIndex,
                               final int columnIndex) {

            final List<String> keyList = new ArrayList<>(tagMap.keySet());
            final Tag tag = tagMap.get(keyList.get(rowIndex));

            if (UNTAGGED.equals(tag.getName())) {
                this.initWithTags(UNTAGGED);
            } else {
                this.untickTags(UNTAGGED);
            }

            super.setValueAt(aValue, rowIndex, columnIndex);
        }


        /** {@inheritDoc} */
        @Override
        public String getColumnName(final int column) {
            if (column == 1) {
                return "Toggled";
            } else {
                return super.getColumnName(column);
            }
        }


    };

    private transient File file;

    public void openFile(final File file) throws FileNotFoundException {
        this.file = file;

        fileLoaded = false;
        cardModel.reset();
        tagModel.reset(true);
        cardTagModel.reset(false);

        new SourceReader(new FileReader(file))
            .readSource(card -> registerCard(card));

        fileLoaded = true;

    }

    private void registerCard(final Card newCard) {

        cardModel.addCard(newCard);

        if (newCard.getTags().isEmpty()) {
            final Tag tagOn = new Tag(TagModel.UNTAGGED, true);
            final Tag tagOff = new Tag(TagModel.UNTAGGED, false);
            tagModel.addTag(tagOn);
            cardTagModel.addTag(tagOff);
        } else {
            for (final String tag : newCard.getTags()) {
                final Tag tagOn = new Tag(tag, true);
                final Tag tagOff = new Tag(tag, false);
                tagModel.addTag(tagOn);
                cardTagModel.addTag(tagOff);
            }
        }
    }


    /**
     * @return the fileLoaded
     */
    public boolean isFileLoaded() {
        return fileLoaded;
    }

    /**
     * @param fileLoaded the fileLoaded to set
     */
    public void setFileLoaded(final boolean fileLoaded) {
        this.fileLoaded = fileLoaded;
    }

    /**
     * @return the tagModel
     */
    public TagModel getTagModel() {
        return tagModel;
    }

    /**
     * @return the cardModel
     */
    public CardModel getCardModel() {
        return cardModel;
    }

    /**
     * @return the cardTagModel
     */
    public TagModel getCardTagModel() {
        return cardTagModel;
    }

    /**
     * @param valueAt
     */
    public void initCardTagFromTag(final String valueAt) {
        cardTagModel.initWithTags(StringUtil.trimArray(valueAt.split(",")));
    }

    /** */
    public void updateCardTable(final int row, final int col) {
        final Card card = cardModel.getCardAt(row);
        card.setTags(cardTagModel.getSelectedTags());
        showTags(cardTagModel.getSelectedTags());

        tagModel.fireTableDataChanged();
        cardModel.fireTableCellUpdated(row, col);
    }

    private void showTags(final String... tags) {
        tagModel.untickTags(tags);
    }

    /**
     * @return
     */
    public boolean isRefreshing() {
        return refreshing;
    }

    /**
     * @param b
     */
    public void setRefreshing(final boolean state) {
        refreshing = state;
    }

    /**
     * @throws IOException
     */
    public void saveToFile(final File file) throws IOException {

        final FileWriter fileWriter = new FileWriter(
            file == null ? this.file.getAbsolutePath()
                    : file.getAbsolutePath());

        final BufferedWriter buffWriter = new BufferedWriter(fileWriter);

        for (int i = 0; i < cardModel.getRowCount(); i++) {
            final Card card = cardModel.getCardAt(i);

            buffWriter.write(card.toSource());
            buffWriter.newLine();
            buffWriter.newLine();
        }

        buffWriter.close();

    }


    boolean isCardSelected(final String[] selectedTags, final Card card) {
        final Ano<Boolean> retval = new Ano<>(false);

        for (final String selected : selectedTags) {
            if (card.getTags().contains(selected)
                    || TagModel.UNTAGGED.equals(selected)
                            && card.getTags().isEmpty()) {
                retval.set(true);
                break;
            }
        }
        return retval.get();
    }

    /**
     * @param selectedFile
     */
    public void exportSelected(final File selectedFile) {

        final String filePath = selectedFile.getAbsolutePath();
        final File file2 = new File(
            selectedFile.getAbsolutePath().substring(0, filePath.indexOf('.'))
                    + "-remnant.txt");

        try {
            file2.createNewFile();
        } catch (final IOException e) {
            LOGGER.log(Level.SEVERE, "File save failed!", e);
        }

        try (FileWriter fileWriter1 = new FileWriter(selectedFile);
                FileWriter fileWriter2 = new FileWriter(file2);
                final BufferedWriter buffWriter1 =
                        new BufferedWriter(fileWriter1);
                final BufferedWriter buffWriter2 =
                        new BufferedWriter(fileWriter2);) {

            for (final Card nextCard : new Iterable<Card>() {
                @Override
                public Iterator<Card> iterator() {
                    return new CardIter(cardModel);
                }
            }) {
                if (isCardSelected(tagModel.getSelectedTags(), nextCard)) {
                    buffWriter1.write(nextCard.toSource());
                    buffWriter1.newLine();
                    buffWriter1.newLine();
                } else {
                    buffWriter2.write(nextCard.toSource());
                    buffWriter2.newLine();
                    buffWriter2.newLine();
                }
            }

        } catch (final IOException ioe) {
            LOGGER.log(Level.SEVERE, "File save failed!", ioe);
        }

    }

}
